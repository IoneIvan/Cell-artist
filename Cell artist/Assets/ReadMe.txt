Hello!

A small video on how to interact with this project:
https://youtu.be/ZSPkMn67x1I



How it works:

Each pixel has 6 data
Multiplication data: red, green, blue
Result data: red, green, blue

Each update, to get the result data, the cells look at the neighboring results and multiply them by their own multiplication data.
The cells then look at the error of their neighbors. If the error of a cell is greater than the error of its neighbors, then the multiplication data of the cell is equal to the neighboring multiplication data that have a smaller error.

There is also a 0.1% chance that the multiplication data will be completely random in the process.
To find the error, simply subtract the result from the sample image and convert it to absolute.



//--------------------------------------------------//


This is one of my experiments with cellular automata.
If you are interested and want to see more, you can subscribe to my YouTube channel or Reddit



This project on github:
https://github.com/IoneIvan/Cell-artist