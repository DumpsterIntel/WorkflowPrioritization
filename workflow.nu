open /home/topiary/Documents/nu/FUCKYOUCLAUDE.csv |
each {|row|
  let status = $row.Status
  let priority = $row.Priority
  let last = $row.'Last Response'
  let age_hours = if ($last | str contains 'day') {
    (($last | str replace ' days ago' '' | str replace ' day ago' '' | into int) * 24)
  } else {
    if ($last | str contains 'hour') {
      ($last | str replace ' hours ago' '' | str replace ' hour ago' '' | into int)
    } else {
      if ($last | str contains 'minute') {
        0
      } else {
        0
      }
    }
  }

  let priority_score = if $priority == 'P1' { 100 } else { if $priority == 'P2' { 90 } else { if $priority == 'P3' { 80 } else { if $priority == 'P4' { 70 } else { 50 } } } }
  let waiting_on_me = if $status == 'Waiting on Me' { if $priority == 'P1' { 10000 } else { 200 } } else { 0 }
  let waiting_on_customer = if $status == 'Waiting on Customer' { -10000 } else { 0 }
  let p2_age_score = if $priority == 'P2' and $age_hours >= 24 { 9.0 + (($age_hours - 24) / 24.0) } else { 0 }
  
  # SLA thresholds
  let is_p2_sla_breach = if $priority == 'P2' { $age_hours > 24 } else { false }
  let is_p3_sla_breach = if $priority == 'P3' { $age_hours > 72 } else { false }
  let is_p4_sla_breach = if $priority == 'P4' { $age_hours > 168 } else { false }
  let out_of_sla = $is_p2_sla_breach or $is_p3_sla_breach or $is_p4_sla_breach
  let is_pending_support = $status == 'Pending Support'
  let is_waiting_on_customer = $status == 'Waiting on Customer'
  let is_waiting_on_engineering = $status == 'Pending Engineering'
  let over_2_weeks = $age_hours > 336
  
  # Bucket assignment using scoring - a case can qualify for multiple buckets, highest precedence wins
  let bucket_score_1 = if ($priority == 'P1' or $out_of_sla or $is_pending_support) { 10.0 } else { 0.0 }
  let bucket_score_2 = if ($out_of_sla == false) { 9.0 } else { 0.0 }
  let bucket_score_3 = if (($priority != 'P1') and ($is_waiting_on_customer or $is_waiting_on_engineering)) { 8.0 } else { 0.0 }
  let bucket_score_4 = if ($over_2_weeks) { 7.0 } else { 0.0 }
  
  let bucket = if $bucket_score_1 > 0 { 1 } else if $bucket_score_2 > 0 { 2 } else if $bucket_score_3 > 0 { 3 } else if $bucket_score_4 > 0 { 4 } else { 2 }
  let score = if $bucket == 1 { 10.0 } else if $bucket == 2 { 9.0 } else if $bucket == 3 { 8.0 } else { 7.0 }

  $row | merge {Bucket: $bucket, Score: $score}
} |
sort-by Bucket Score |
select Case Priority 'Last Response' Status Jira Bucket Score |
to csv |
save -f workflow_buckets.csv
