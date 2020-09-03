Project Scope:

To   familiarize   novice   programmers   with   multi-threading concepts, I created a visualization tool to help showcase communication patterns between threads. The tool  is  accessible  to  users  through  any  internet browser with JavaScript enabled.

This project has two parts:
1. A parser that reads a log file from a Java threading library to record what the threads are doing.
2. A visualization tool that draws that information.

The log file is structured using double dashes as delimiters with each thread report separated by a newline. Each line of the log file contains the time in nanoseconds the thread action was recorded, the thread name, a detailed description of the thread action, and the type of thread action that occurred. Using C libraries Flex and Bison, we parse the log file based on the action the thread is performing. We can also prepend and append Javascript during the parsing process to help create the tool. At the end of parsing, we have a fully executable Javascript file.

The main task of the visualization tool is to model the thread actions over time. In the tool, threads exist on a two-dimensional graph, where the x-axis defines the number of threads and the y-axis denotes the time. On initialization, a thread will be incremented to its own line on the y-axis at a time t specified on the x-axis in nanoseconds. This linear design allows for incremental updates of time to be shown as the threads complete their execution. The legend to the right of the graph depicts a list of threads currently present in the program. Below the graph depiction, a thread table in Figure 4 details the state and description of the thread at the current time in the program. Charts.JS was the main library used in the design of this tool.  

There are 2 fully working demos of this project in /thread-vis/tool/. car-demo and hotel-demo simulate multi-threading programs that mimic these environments.

How to Demo:

1. Download the project folder.
2. run car-demo or hotel-demo in the browser by double-clicking on them.
