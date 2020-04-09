import 'dart:io';
import 'package:image/image.dart';

void main(List<String> args) {
  // ler uma imagem
  Image image = decodeImage(File('placa_carro.jpg').readAsBytesSync());

  image = convertePraBinario(image, limiar: 112);

  // Salva a saida como PNG.
  File('saida.png')..writeAsBytesSync(encodePng(image));
}

/// Retorna o valor da luminância (escala de cinza) da cor.
int obtemLuminanciaRgb(int r, int g, int b) {
  return (0.299 * r + 0.587 * g + 0.114 * b).round();
}

/// converter cores em escala de cinza usando o método de luminosidade
/// ele  calcula a média dos valores, mas forma uma média ponderada para explicar a percepção humana.
/// Somos mais sensíveis ao verde do que outras cores, por isso o verde é mais pesado.
/// A fórmula da luminosidade é 0,21 R + 0,72 G + 0,07 B aproximadamente
/// Converta a imagem em escala de cinza.
Image escalaDeCinza(Image src) {
  var p = src.getBytes();
  for (var i = 0, len = p.length; i < len; i += 4) {
    var l = obtemLuminanciaRgb(p[i], p[i + 1], p[i + 2]);
    p[i] = l;
    p[i + 1] = l;
    p[i + 2] = l;
  }
  return src;
}

/// Retorna o valor binario
int obtemCorBinaria(int r, int g, int b, {limiar = 125}) {
  var corCinza = (0.299 * r + 0.587 * g + 0.114 * b).round();

  if (corCinza > limiar) {
    return 255;
  } else {
    return 0;
  }
}

/// Converta a imagem em binario preto e branco puro
Image convertePraBinario(Image src, {limiar = 125}) {
  var p = src.getBytes();
  for (var i = 0, len = p.length; i < len; i += 4) {
    var l = obtemCorBinaria(p[i], p[i + 1], p[i + 2], limiar: limiar);
    p[i] = l;
    p[i + 1] = l;
    p[i + 2] = l;
  }
  return src;
}
