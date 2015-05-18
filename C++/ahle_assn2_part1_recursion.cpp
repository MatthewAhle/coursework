/******************************************************************************
** Program Filename: 		ahle_assn2_part1_recursion.cpp
** Author:			Matthew Ahle
** Date:			1/19/2014
** Description:			This program has a main function that calls a
**				recursive function until a user-defined level
**				is reached.  The program then throws an excep-
**				tion and terminates with a closing statement.
** Input:			The level at which the program will throw an
**				exception.
** Output:			The program outputs a line indicating that a
**				new level has been reached, then outputs a 
**				terminating statement when the exception is
**				throw and the program ends.
******************************************************************************/


#include <iostream>			// Libraries and using statements

using std::cin;
using std::endl;
using std::cout;


/******************************************************************************
** Function:			recurse
** Description:			The recursive function, called by main, which
**				iterates as many times as needed until it reac-
**				hes the user-defined level at which an excep-
**				tion is thrown.  It then throws the exception,
**				which is caught in main, and the program ends.
** Parameters:			int count, int user_input
** Pre-conditions:		main
** Post-conditions:		N/A
******************************************************************************/ 


int recurse(int count, int user_input) 
{	
	
	if (user_input == 0)		// If user inputs 0, exception thrown
	   	throw count;

	if (count == user_input)	
	   return count;
	else
		cout << "Recursive function iterating through level ";
       		cout << count << endl;	

	++count;			// Count increments
	recurse(count, user_input);	// Recurse calls itself
		
	if (count == user_input)	// Exception thrown when count = input
		throw count;
}


/******************************************************************************
** Function:			main
** Descrption:			The main function takes user input and then 
**				initiates the recursive loop through a try-block
**				and when recurse throws an exception, main
**				catches it, outputs some text indicating the
**				exception was caught, then terminates.
** Parameters:			N/A
** Pre-conditions:		N/A
** Post-conditions:		N/A
******************************************************************************/


int main()
{
	int count = 0;
   	int user_input;
	cout << "Enter the level at which an exception will be thrown." << endl;
	cin >> user_input;
	
	try				// Calling recurse through a try-block
	{
	recurse(count, user_input);
	}
	catch (int count)		// Catching exception
	{
	cout << "Exception caught at level " << count;
       	cout << ", terminating program." << endl;
	}
	
return 0;				// Program terminates
}
