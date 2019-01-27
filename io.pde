

boolean fileExists(String fileName) { 
  String path = dataPath(fileName);
  File f = new File(path);
  if (f.exists()) {
    return true;
  }

  println(path + " doesn't exist...");
  return false;
}

public static boolean deleteDir(File dir) 
{ 
  if (dir.isDirectory()) 
  { 
    String[] children = dir.list(); 
    for (int i=0; i<children.length; i++)
      deleteDir(new File(dir, children[i])); 
  }  
  // The directory is now empty or this is a file so delete it 
  println("deleting: " + dir.getName());
  return dir.delete(); 
} 


class Parameter {
  String key;
  boolean on, click;
  float x, y, z;
  
  Parameter(String key, boolean on, boolean click, float x, float y, float z) {
    this.key = key;
    this.on = on;
    this.click = click;
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

HashMap<String,Parameter> keyParameters = new HashMap<String, Parameter>();

Parameter par(String key) {
  Parameter parameter = keyParameters.get(key);
  if (parameter == null) {
    parameter = createParameter(key);
  }
  return parameter;
}

void loadParameters() {
  String parameterFileName = "parameters.txt";
  if (!fileExists(parameterFileName))
    return;

  BufferedReader reader = createReader(parameterFileName);
  
  String line = readLine(reader);

  while (line != null) {
    String[] pieces = split(line, TAB);
    int index = 0;
    String key = pieces[index++];
    boolean on = boolean(pieces[index++]);
    boolean click = boolean(pieces[index++]);
    float x = float(pieces[index++]);
    float y = float(pieces[index++]);
    float z = float(pieces[index++]);
    keyParameters.put(key, new Parameter(key, on, click, x, y, z));

    line = readLine(reader);    
  }

  try {
    reader.close();
  } catch (IOException e) {
    println(e);
  }
}


String readLine(BufferedReader reader) {
  String line;
  try {
    line = reader.readLine();
  } catch (IOException e) {
    println(e);
    line = null;
  }
  return line;
}

Parameter createParameter(String key) {
  Parameter parameter = new Parameter(key, false, false, 0, 0, 0);
  keyParameters.put(key, parameter);
  println("created keyParameter: " + key);
  return parameter;
}

void saveParameters() {
  String fileName = "parameters.txt";
  String path = dataPath(fileName);

  PrintWriter output = createWriter(path); 
  Set<String> keys = keyParameters.keySet();
  for (String key : keys) {
    Parameter parameter = keyParameters.get(key);
    output.println(
      key + TAB
      + parameter.on + TAB
      + parameter.click + TAB
      + parameter.x + TAB
      + parameter.y + TAB
      + parameter.z + TAB
    );       
  }
  output.flush();
  output.close();
  println("saved " + path);
}

void drawParameters() {
  if (keyDown != null) {
    camera();
  
    int space = 10;
    textSize(space);
    stroke(0);
    fill(0);
    rect(mouseX, mouseY, 60, -space * 5);
    fill(255);

    int index = 0;
    Parameter parameter = par(keyDown);
    text(parameter.key + ".on = " + parameter.on, mouseX, mouseY - space * index++);
    text(parameter.key + ".click = " + parameter.click, mouseX, mouseY - space * index++);
    text(parameter.key + ".x = " + parameter.x, mouseX, mouseY - space * index++);
    text(parameter.key + ".y = " + parameter.y, mouseX, mouseY - space * index++);
    text(parameter.key + ".z = " + parameter.z, mouseX, mouseY - space * index++);
  }
}