The hope of the workflow.nu is to create action. Not be perfect at determining what you should do next. 

Because typically action is better than inaction for as long as progress is being made, 

HOW TO USE

Syntax
nu workflow.nu Test.csv Solution.csv

workflow.nu <input_file> <output_file>


Expected Output

╭───┬──────┬──────────┬────────────────┬─────────────────────┬──────┬────────┬───────╮
│ # │ Case │ Priority │ Last Response  │       Status        │ Jira │ Bucket │ Score │
├───┼──────┼──────────┼────────────────┼─────────────────────┼──────┼────────┼───────┤
│ 0 │ A    │ P1       │ 2 hours ago    │ Waiting on Customer │ Yes  │      1 │ 10.00 │
│ 1 │ B    │ P2       │ 26 hours ago   │ Waiting on Me       │ No   │      1 │ 10.00 │
│ 2 │ C    │ P3       │ 4 days ago     │ Pending Support     │ Yes  │      1 │ 10.00 │
│ 3 │ D    │ P1       │ 30 minutes ago │ Pending Engineering │ Yes  │      1 │ 10.00 │
│ 4 │ F    │ P4       │ 8 days ago     │ Waiting on Customer │ No   │      1 │ 10.00 │
│ 5 │ H    │ P2       │ 20 hours ago   │ Pending Support     │ No   │      1 │ 10.00 │
│ 6 │ E    │ P2       │ 3 hours ago    │ Waiting on Me       │ Yes  │      2 │  9.00 │
│ 7 │ G    │ P3       │ 2 days ago     │ Working             │ No   │      2 │  9.00 │
╰───┴──────┴──────────┴────────────────┴─────────────────────┴──────┴────────┴───────╯
