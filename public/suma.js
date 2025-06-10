// Esta funcion no verifica nada
/*
function sumar(a, b) {
  return a + b;
}
*/

// Esta funcion verifica los caracteres no numéricos
function sumar(a, b) {
  const numA = Number(a);
  const numB = Number(b);

  return numA + numB;
}


if (typeof document !== 'undefined') {
  document.addEventListener('DOMContentLoaded', function () {
    const inputA = document.getElementById('inputA');
    const inputB = document.getElementById('inputB');
    const boton = document.getElementById('sumarBtn');
    const resultado = document.getElementById('resultado');

    boton.addEventListener('click', function () {
      const a = parseFloat(inputA.value);
      const b = parseFloat(inputB.value);

      if (isNaN(a) || isNaN(b)) {
        resultado.textContent = 'Por favor, ingresa números válidos.';
        return;
      }

      const suma = sumar(a, b);
      resultado.textContent = `Resultado: ${suma}`;
    });
  });
}

// Exportar para test
if (typeof module !== 'undefined') {
  module.exports = { sumar };
}
