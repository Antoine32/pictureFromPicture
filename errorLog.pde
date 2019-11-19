void errorLog(String message) {
  message = day() + "/" + month() + "/" + year() + " " + minute() + ":" + second() + " - \n" + message;
  message += "Think about sending a bug report if you want to help developement, the more info you can give about the situation the better the program can get. \n";
  print(message);
  try {
    File logTxt = findFile("", "log.txt");
    output = new FileWriter(logTxt, true);
    buffWriter = new BufferedWriter(output);
    buffWriter.write('\n' + message);
    buffWriter.flush();
    output.flush();
    buffWriter.close();
    output.close();
  }
  catch(Exception e) {
    e.printStackTrace();
    PrintWriter writer = createWriter("log.txt");
    writer.print(message);
    writer.flush();
    writer.close();
  }
  exit();
}
