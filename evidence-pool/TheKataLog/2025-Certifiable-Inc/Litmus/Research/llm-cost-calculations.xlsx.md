## Costings (2)

| | Scenario | Model | Cost per test 1 | Cost per test 2 |  | Test 1 tokens | Test 1 num questions | Test 2 tokens | Test 2 num personas |  | PP 1000 input tokens | PP 1000 output tokens |  | Knowledge bases per query | Guard rails per token | 
| | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | 
| | Large | Llama 3.3 Instruct (70B) | 0.28200000000000003 | 1.155 |  | 15000 | 30 | 150000 | 15 |  | 0.00036 | 0.00036 |  | 0.003 | 2e-06 | 

## Assumptions

| | Scenario | Test 1 tokens | Test 1 num questions | Test 2 tokens | Test 2 num personas | 
| | --- | --- | --- | --- | --- | 
| | Small | 5000 | 10 | 50000 | 5 | 
| | Medium | 10000 | 20 | 100000 | 10 | 
| | Large | 15000 | 30 | 150000 | 15 | 

## Models

| | Model | PP 1000 input tokens | PP 1000 output tokens | 
| | --- | --- | --- | 
| | Llama 3.3 Instruct (70B) | 0.00036 | 0.00036 | 
| | Claude 3.5 Sonnet | 0.0015 | 0.0075 | 

## Tools

| | Knowledge bases per query | Guard rails per token | 
| | --- | --- | 
| | 0.003 | 2e-06 | 
