import 'package:flutter/material.dart';
import 'package:poker_demo/utils/utils.dart';

class ButtonWidget extends StatelessWidget {
  /// 按钮文本
  final String text;
  /// 按钮在可用时的点击事件
  final VoidCallback onTap;
  /// 按钮是否禁用，若为true显示灰色，并且不执行onTap函数
  final bool disabled;
  ButtonWidget(this.text, this.onTap, {Key? key, this.disabled = false}) : super(key: key);

  /// 按钮按下时呈现按压效果
  final isTappingVN = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onPanDown: (e) => isTappingVN.value = disabled ? false : true,
      onTapUp: (e) => isTappingVN.value = false,
      onPanEnd: (e) => isTappingVN.value = false,
      onTap: disabled ? null : onTap,
      child: ValueListenableBuilder<bool>(
        valueListenable: isTappingVN,
        builder: (context, isTapping, child) {
          final color = disabled ? Colors.grey : theme.primaryColor;
          return Stack(
            children: [
              /// 按钮下方的阴影，在按压过程中会被覆盖
              Positioned(
                top: 4,
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: ShapeBorderClipper(shape: PixelShapeBorder(radius: 2)),
                  child: Container(color: color.withOpacity(.5)),
                ),
              ),
              /// 按钮本体，按压过程中往下偏移
              Positioned(
                top: isTapping ? 4 : 0,
                bottom: isTapping ? 0 : 4,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: ShapeBorderClipper(shape: PixelShapeBorder(radius: 2)),
                  child: Container(
                    padding: EdgeInsets.only(top: 4),
                    alignment: Alignment.center,
                    color: color,
                    child: Text(text, style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
