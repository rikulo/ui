//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Aug 14, 2012 16:28:52 AM
//Author: simonpai
part of rikulo_html;

/** A matrix object capable of common mathematical operations, such as sum, 
 * scalar multiplication, matrix multiplication, etc. The entries are accessible
 * with two-dimensional-array-like getter and setter.
 */
class Matrix {
  
  /** The number of rows. */
  final int rows;
  
  /** The number of columns. */
  final int columns;
  
  final List<MatrixRow> _mrs;
  final List<num> _en;
  
  /** Create a matrix of size [rows] by [columns].
   * + If [entries] is provided, the matrix is initialized with these values. 
   * [entries] must have size [rows]*[columns].
   * + If [entries] is not provied, the matrix is initialized with null values.
   */
  Matrix(int rows, int columns, [List<num> entries]) :
  this.rows = rows, this.columns = columns, _mrs = new List<MatrixRow>(rows),
  _en = new List<num>(rows * columns) {
    if (entries != null) {
      final int size = rows * columns;
      if (entries.length != size)
        throw new ArgumentError(entries);
      for (int i = 0; i < size; i++)
        _en[i] = entries != null ? entries[i] : 0;
    }
  }
  
  /** Create a matrix as a copy of the given matrix [m].
   */
  Matrix.clone(Matrix m) : this(m.rows, m.columns, m._en); 
  
  MatrixRow operator [](int row) {
    MatrixRow mr = _mrs[row];
    if (mr == null)
      mr = _mrs[row] = new _MatrixRow(this, row);
    return mr;
  }
  
  /** Sum. */
  Matrix operator +(Matrix m) {
    _assertSameSize(m);
    return _generate(rows, columns, (int i) => _en[i] + m._en[i]);
  }
  
  /** Subtraction. */
  Matrix operator -(Matrix m) {
    _assertSameSize(m);
    return _generate(rows, columns, (int i) => _en[i] - m._en[i]);
  }
  
  /** Scalar or Matrix multiplication, if the operand is a number of Matrix, 
   * respectively. In matrix multiplication case, the column count of the left 
   * operand must be equal to the row count of the right operand.
   */
  Matrix operator *(var m) {
    if (m is num)
      return _generate(rows, columns, (int i) => _en[i] * m);
    else if (m is Matrix) {
      if (m.rows != columns)
        throw new ArgumentError(m);
      final int k = m.rows, nrs = rows, ncs = m.columns;
      Matrix res = new Matrix(nrs, ncs);
      for (int r = 0; r < nrs; r++)
        for (int c = 0; c < ncs; c++)
          res._en[r * ncs + c] = _iprod(m, r, c, k);
      return res;
    } else
      throw new ArgumentError(m);
  }
  
  /** Scalar division. */
  Matrix operator /(num scalar) {
    // TODO: divide by zero exception
    return _generate(rows, columns, (int i) => _en[i] / scalar);
  }
  
  // TODO: supply .det(), using Gauss method
  
  String toString() {
    StringBuffer sb = new StringBuffer("[[");
    for (int r = 0; r < rows; r++) {
      if (r > 0)
        sb.write("] [");
      for (int c = 0; c < columns; c++) {
        if (c > 0)
          sb.write(" ");
        sb.write(_get(r, c));
      }
    }
    return (sb..write("]]")).toString();
  }
  
  // helper //
  void _assertSameSize(Matrix m) {
    if (m == null || m.rows != rows || m.columns != columns)
      throw new ArgumentError(m);
  }
  
  int _index(int r, int c) => r * columns + c;
  
  num _get(int r, int c) => _en[_index(r, c)];
  
  void _set(int r, int c, num v) {
    _en[_index(r, c)] = v;
  }
  
  num _iprod(Matrix m1, int r, int c, int k) {
    num sum = 0;
    for (int i = 0; i < k; i++)
      sum += _en[r * k + i] * m1._en[i * k + c];
    return sum;
  }
  
  static Matrix _generate(int rs, int cs, num f(int i)) {
    final int size = rs * cs;
    final Matrix m = new Matrix(rs, cs);
    for (int i = 0; i < size; i++)
      m._en[i] = f(i);
    return m;
  }
  
}

/** An intermediate object for supporting the two-dimensional-array-like entry 
 * access of [Matrix].
 */
abstract class MatrixRow {
  
  /** The getter of [Matrix] entry.
   */
  num operator [](int column);
  /** The setter of [Matrix] entry.
   */
  void operator []=(int column, num value);
}

class _MatrixRow implements MatrixRow {
  final Matrix _m;
  final int _r;
  
  _MatrixRow(this._m, this._r);
  
  num operator [](int column) => _m._get(_r, column);
  void operator []=(int column, num value) => _m._set(_r, column, value);
}

/** A CSS-compatible transformation object, as a special case of a 3-by-3 
 * [Matrix].
 */
class Transformation extends Matrix {
  
  /** Create a transformation matrix with the following entries:
   *   [m00] [m01] [m02]
   *   [m10] [m11] [m12]
   *    0   0   1
   * TODO
   */
  Transformation(num m00, num m01, num m02, num m10, num m11, num m12) : 
    super(3, 3, [m00, m01, m02, m10, m11, m12, 0, 0, 1]);
  
  /** Create a transformation by cloning the given [t].
   */
  Transformation.clone(Transformation t) :
    this(t._get(0, 0), t._get(0, 1), t._get(0, 2), 
         t._get(1, 0), t._get(1, 1), t._get(1, 2));
  
  /** Create an identity transformation.
   */
  Transformation.identity() : 
    this(1, 0, 0, 0, 1, 0);
  
  /** Create a transformation of scaling by [scalar].
   */
  Transformation.scale(num scalar) : 
    this(scalar, 0, 0, 0, scalar, 0);
  
  /** Create a transformation of rotation by [rad], in the unit of radian.
   */
  Transformation.rotate(num rad) : 
    this(cos(rad), -sin(rad), 0, sin(rad), cos(rad), 0);
  
  /** Create a transformation of transition by [offset].
   */
  Transformation.transit(Point offset) : 
    this(1, 0, offset.x, 0, 1, offset.y);
  
  /** Apply the tranformation on [offset].
   */
  Point apply(Point offset) => new Point(
    _en[0] * offset.x + _en[1] * offset.y + _en[2],
    _en[3] * offset.x + _en[4] * offset.y + _en[5]);
  
  /** Transformation composition, as a special case of [Matrix] multiplication.
   */
  Transformation operator *(Transformation m) {
    return new Transformation(
      _iprod(m, 0, 0, 3), _iprod(m, 0, 1, 3), _iprod(m, 0, 2, 3), 
      _iprod(m, 1, 0, 3), _iprod(m, 1, 1, 3), _iprod(m, 1, 2, 3));
  }
  
  /** Retrieve the transition part of this transformation, as an Point.
   */
  Point get transition => new Point(_get(0, 2), _get(1, 2));
  
  /** Return a new transformation of the same linear map, but with respect to 
   * a different [origin]. This is, effectively, a change of basis on the 
   * transformation.
   */
  Transformation originAt(Point origin) =>
      new Transformation.clone(this)
      .._set(0, 2, (_get(0,0)-1) * origin.x + _get(0,1) * origin.y + _get(0,2))
      .._set(1, 2, _get(1,0) * origin.x + (_get(1,1)-1) * origin.y + _get(1,2));
  
}
