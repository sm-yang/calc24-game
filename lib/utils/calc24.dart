class Calc24Util {
  /// 能够算出24点的所有可用运算式
  static final operations = [
    'a+b+c+d',
    'a+b+c-d',
    'a+b+c*d',
    'a+(b+c)*d',
    '(a+b+c)*d',
    'a+b+c/d',
    'a+(b+c)/d',
    '(a+b+c)/d',
    'a+(b-c)*d',
    '(a+b-c)*d',
    '(a+b)*(c+d)',
    'a+b*c-d',
    '(a+b)*c-d',
    '(a+b)*(c-d)',
    'a+b*c*d',
    '(a+b)*c*d',
    '(a+b*c)*d',
    'a+b*c/d',
    '(a+b)*c/d',
    '(a+b*c)/d',
    '(a+b/c)*d',
    '(a-b-c)*d',
    '(a-b)*c-d',
    '(a-b)*(c-d)',
    '(a-b)*c*d',
    '(a-b*c)*d',
    '(a-b)*c/d',
    '(a-b/c)*d',
    'a*b+c*d',
    'a*b+c/d',
    'a*b-c-d',
    'a*b-c*d',
    '(a*b-c)*d',
    'a*b-c/d',
    '(a*b-c)/d',
    'a*b*c-d',
    'a*b*c*d',
    'a*b*c/d',
    'a*b/(c+d)',
    'a*b/c-d',
    'a*b/(c-d)',
    'a*(b/c-d)',
    'a*b/c/d',
    '(a/b-c)*d',
    'a/(b-c/d)',
    'a/(b/c-d)',
  ];

  /// 判断四个数字是否能得到24
  static String getSolution (final List<int> nums) {
    /// 拿到四个数字的全排列
    final combinations = getCombinations(nums);
    for (final combination in combinations) {
      for (final operation in operations) {
        /// 将排列组合与计算式结合
        final expression = operation
            .replaceFirst('a', combination[0].toString())
            .replaceFirst('b', combination[1].toString())
            .replaceFirst('c', combination[2].toString())
            .replaceFirst('d', combination[3].toString());
        if (computeStr(expression) == 24) return expression;
      }
    }
    return '';
  }

  /// 字符串表达式计算
  static double computeStr (String input) {
    /// 解析表达式，express 只储存数字和加减乘除号
    final express = <String>[];
    while (input.isNotEmpty) {
      /// 遇到括号时，解析括号里的表达式，并优先计算
      if (input[0] == '(') {
        var nested = 1;
        for (var i = 1, len = input.length; i < len; i ++) {
          switch (input[i]) {
            case '(': nested ++; break;
            case ')': nested --; break;
          }
          if (nested == 0) {
            express.add(computeStr(input.substring(1, i)).toString());
            input = input.substring(i + 1);
            break;
          }
        }
        if (nested > 0) throw Exception('Invalid string');
      } else {
        final exp = RegExp(r'^(\d|10|[\+\-\*\/])').stringMatch(input)!;
        express.add(exp);
        input = input.substring(exp.length);
      }
    }
    /// 计算表达式
    /// 进行两轮循环，第一轮先计算乘除法，第二轮才计算加减法
    var i = 1;
    var len = express.length;
    var hasPrior = true;
    while (len > 1) {
      final operator = express[i];
      /// hasPrior为true时，表示是第一轮计算，只计算乘除法
      /// 为false表示是第二轮计算，才计算加减法
      if (hasPrior && (operator == '*' || operator == '/') || !hasPrior) {
        final num1 = double.parse(express[i - 1]);
        final num2 = double.parse(express[i + 1]);
        late final double temp;
        switch (operator) {
          case '*': temp = num1 * num2; break;
          case '/': temp = num1 / num2; break;
          case '+': temp = num1 + num2; break;
          case '-': temp = num1 - num2; break;
        }
        express[i - 1] = temp.toString();
        express..removeAt(i)..removeAt(i);
        i -= 2;
        len -= 2;
      }
      /// 进入第二轮计算
      i += 2;
      if (hasPrior && i == len) {
        i = 1;
        hasPrior = false;
      }
    }
    return double.parse(express[0]);
  }

  /// 全排列算法（重复） - 回溯
  static List<List<int>> getCombinations (final List<int> input) {
    final nums = input.sublist(0)..sort((a, b) => a - b);
    final len = nums.length;
    final res = <List<int>>[];
    final inputted = List.filled(nums.length, false);
    void backtrack (final int index, final List<int> perm) {
      if (index == len) return res.add(perm.sublist(0, len));
      for (var i = 0; i < len; i ++) {
        if (inputted[i] || (i > 0 && nums[i] == nums[i - 1] && !inputted[i - 1])) continue;
        perm.add(nums[i]);
        inputted[i] = true;
        backtrack(index + 1, perm);
        perm.removeLast();
        inputted[i] = false;
      }
    }
    backtrack(0, []);
    return res;
  }
}