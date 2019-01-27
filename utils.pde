import java.awt.Toolkit;

float e = 2.71828182845904523536028747135266249775724709369995;

float fmod(float f, int mod) {
  if (f < 0)
    return (((f % mod) + mod) % mod);
  return f % mod;
}

float triangle(float pos) {
  return 1 - abs((float) (1 - fmod(pos, 1) * 2));
}

float square(float pos) {
  return round(fmod(pos, 1));
}

float sine(float pos) {
  return sin(pos * 2 * PI);
}

float sineSig(float pos) {
  return sine(pos) * 0.5 + 0.5;
}

float cosine(float pos) {
  return cos(pos * 2 * PI);
}
float cosineSig(float pos) {
  return cosine(pos) * 0.5 + 0.5;
}

float sigmoid(float pos, float k) {
  pos = fmod(pos, 2);

  if (pos >= 1)
    pos = (2 - pos);

  return pos < 0.5 
    ? (k * pos * 2) / (k - pos * 2 + 1) / 2
    : 1 - (k * (1 - pos) * 2) / (k - (1 - pos) * 2 + 1) / 2;


  //return 1.0 - 2.0 / (pow(e, 2 * pos) + 1);
  //return pos / sqrt(1.0 + pow(pos, 2));
  //return 1.0 / (1.0 + pow(e, pos * -1));
}


void ding() {
  Toolkit.getDefaultToolkit().beep();
}