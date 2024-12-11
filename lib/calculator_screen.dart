//IM-2021-092

import 'package:flutter/material.dart';
import 'button_values.dart';
import 'dart:math'; // Advanced mathematical operations like square root

class CalculatorScreen extends StatefulWidget {
  //to update interface dynamically
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ""; // First operand
  String operand = ""; // Operator (+, -, *, /)
  String number2 = ""; // Second operand
  List<String> history = []; // Stores the history of calculations
  bool calculationDone = false; // to track if a calculation has been completed

  @override
  Widget build(BuildContext context) {
    // Retrieve screen size to ensure responsive layout
    final screenSize = MediaQuery.of(context)
        .size; //provides information about the device's screen size

    return Scaffold(
      //provides the basic structure of the screen
      appBar: AppBar(
        //Displays an icon for history
        actions: [
          IconButton(
            icon: const Icon(Icons.history), // Icon to open calculation history
            onPressed: () => showHistory(context), // Opens the history modal
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0" // Default display when no input is provided
                        : "$number1$operand$number2", // Display current input
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            // Layout for calculator buttons
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: screenSize.width /
                          4, // Button width (1/4th of the screen)
                      height: screenSize.width /
                          5, // Button height proportional to width
                      child: buildButton(value), // Generate each button
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  //Button widget
  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        // Button appearance
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge, //Button shape with its boundaries
        shape: OutlineInputBorder(
          borderSide: const BorderSide(),
          borderRadius: BorderRadius.circular(5),
        ),
        child: InkWell(
          //Button responsive with taps
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 30,
                  color: getTextColor(value)),
            ),
          ),
        ),
      ),
    );
  }

  // Handles the logic when a button is tapped
  void onBtnTap(String value) {
    if (calculationDone && value != Btn.calculate) {
      clearAll(); // Clear inputs for new calculation
    }

    if (value == Btn.del) {
      delete(); // Handle delete button
      return;
    }
    if (value == Btn.clr) {
      clearAll(); // Handle clear button
      return;
    }
    if (value == Btn.per) {
      convertToPercentage(); // Handle percentage conversion
      return;
    }
    if (value == Btn.calculate) {
      calculate(); // Perform the calculation
      return;
    }
    if (value == Btn.sqrt) {
      calculateSquareRoot(); // Handle square root calculation
      return;
    }
    appendValue(value); // Append button value to the input
  }

  // Calculate the square root of the current input
  void calculateSquareRoot() {
    if (number1.isNotEmpty && operand.isEmpty && number2.isEmpty) {
      final number = double.parse(number1);
      setState(() {
        number1 = number >= 0 // Checks if the number is non-negative
            ? sqrt(number).toStringAsPrecision(3)
            : "Error"; // Handle negative numbers
        calculationDone = true; // Mark calculation as completed
      });
    }
  }

  // Perform the calculation based on the operator
  void calculate() {
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

    final double num1 =
        double.tryParse(number1) ?? 0; // converts strings to doubles
    final double num2 = double.tryParse(number2) ?? 0;

    if (operand == Btn.divide && num2 == 0) {
      // Handle division by zero
      setState(() {
        number1 = "Error";
        operand = "";
        number2 = "";
        calculationDone = true;
      });
      return;
    }

    double result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2; // Perform addition
        break;
      case Btn.subtract:
        result = num1 - num2; // Perform subtraction
        break;
      case Btn.multiply:
        result = num1 * num2; // Perform multiplication
        break;
      case Btn.divide:
        result = num1 / num2; // Perform division
        result = double.parse(
            result.toStringAsFixed(8)); // Round off to 8 decimal points
        break;
    }

    setState(() {
      history.add(
          "$number1 $operand $number2 = ${result.toString()}"); // Add to history
      number1 = result.toString();
      if (number1.endsWith(".0")) {
        //Removing Unnecessary Decimal Places
        number1 =
            number1.substring(0, number1.length - 2); // Remove unnecessary ".0"
      }
      operand = ""; // Clear operator
      number2 = ""; // Clear second operand
      calculationDone = true; // Mark calculation as completed
    });
  }

  // Convert the current input to a percentage
  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate(); // Perform the calculation first
    }

    if (operand.isNotEmpty) return;

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}"; // Convert to percentage
      operand = "";
      number2 = "";
      calculationDone = true; // Mark calculation as completed
    });
  }

  // Clear all inputs and reset the calculator
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
      calculationDone = false; // Reset calculation
    });
  }

  // Deletes the last character in the current input
  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {
      calculationDone = false; // Reset calculation
    });
  }

  // Append value to the current input
  void appendValue(String value) {
    if (value == "-" && number1.isEmpty && operand.isEmpty) {
      number1 = "-"; // Handle negative numbers
      setState(() {});
      return;
    }

    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate(); // Perform calculation if both operands are set
      }
      operand = value; // Set the operator
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot))
        return; // Prevent multiple dots
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0."; // Prepend "0."
      }
      number1 += value; // Append to first operand
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot))
        return; // Prevent multiple dots
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        value = "0."; // Prepend "0."
      }
      number2 += value; // Append to second operand
    }
    setState(() {
      calculationDone = false; // Reset calculation
    });
  }

  // Show calculation history in a modal bottom sheet
  void showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            ListTile(
              title: const Text('History'), // Title for history modal
              trailing: IconButton(
                icon: const Icon(Icons.delete), // Clear history icon
                onPressed: () {
                  setState(() {
                    history.clear(); // Clear all history
                  });
                  Navigator.pop(context); // Close modal
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: history.length, // Number of history items
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(history[index]), // Display each history entry
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // Text color of the buttons
  Color getTextColor(String value) {
    if ([Btn.del, Btn.clr, Btn.per].contains(value)) {
      return const Color.fromARGB(255, 32, 32, 32);
    }
    return Colors.white;
  }

//Background color of the buttons
  Color getBtnColor(value) {
    return [Btn.del, Btn.clr, Btn.per].contains(value)
        ? const Color.fromARGB(255, 171, 172, 173)
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate,
          ].contains(value)
            ? const Color.fromARGB(255, 233, 142, 38)
            : const Color.fromARGB(221, 47, 47, 47);
  }
}
