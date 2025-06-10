/*
function sumar(a, b) {
  return a + b;
}
*/

function sumar(a, b) {
  const numA = Number(a);
  const numB = Number(b);

  if (isNaN(numA) || isNaN(numB)) {
    return NaN;
  }

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

      // Validación básica
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
