// suma.test.js
const { sumar } = require('./public/suma');

test('sumar 2 + 3 es igual a 5', () => {
  expect(sumar(2, 3)).toBe(5);
});

test('sumar números negativos', () => {
  expect(sumar(-4, -6)).toBe(-10);
});

test('sumar con cero', () => {
  expect(sumar(0, 7)).toBe(7);
});

/*
test('falla intencional', () => {
  expect(1).toBe(2);  // Esto falla
});
*/

test('no debe permitir letras como entrada', () => {
  expect(sumar("a", "3")).toBeNaN();
});
