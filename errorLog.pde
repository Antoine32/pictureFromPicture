// Function that makes error log and print them on the console
void errorLog(String message, boolean critic) {// message -> the message to show to the user; critic -> if the issu justify shuting down the program
  // Adds the date/month/year to the message to tell the user when the message occured and ask him to repport it if he wishes to help the dev team
  message = '\n' + day() + "/" + month() + "/" + year() + " " + minute() + ":" + second() + " - \n" + message + '\n'
    + "Think about sending a bug report if you want to help developement, the more info you can give about the situation the better the program can get. \n";
  print(message);
  try {
    File logTxt = findFile("", "log.txt");
    output = new FileWriter(logTxt, true);
    buffWriter = new BufferedWriter(output);
    buffWriter.write(message);
    buffWriter.flush();
    output.flush();
    buffWriter.close();
    output.close();
  }
  catch(Exception e) {
    e.printStackTrace();
  }

  if (critic) stop();
}
