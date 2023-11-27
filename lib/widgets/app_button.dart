import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    Key? key,
    this.tooltip,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.color,
    this.elevation,
    this.shadowColor,
    this.borderRadius,
    this.hoverRadius,
    this.hoverColor,
    this.splashColor,
    this.splashRadius,
    this.colorOnClick,
    this.decoration,
    required this.onTap,
    this.child,
  }) : super(key: key);
  final String? tooltip;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? elevation;
  final Color? shadowColor;
  final BorderRadius? borderRadius;
  final BorderRadius? hoverRadius;
  final Color? splashColor;
  final Color? hoverColor;
  final double? splashRadius;
  final Color? colorOnClick;
  final Function? onTap;
  final Widget? child;
  final BoxDecoration? decoration;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool disabled = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip ?? '',
      showDuration: const Duration(seconds: 1),
      waitDuration: const Duration(seconds: 1),
      child: ClipRect(
        child: Container(
          decoration: widget.decoration,
          width: widget.width ?? 60,
          height: widget.height ?? 30,
          margin: widget.margin ?? const EdgeInsets.all(0),
          padding: widget.padding ?? const EdgeInsets.all(0),
          child: Material(
            color: widget.color ?? Colors.transparent,
            elevation: widget.elevation ?? 1,
            shadowColor: widget.shadowColor ?? Colors.transparent,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
            child: InkWell(
              onTap: disabled
                  ? null
                  : () async {
                      setState(() {
                        disabled = true;
                      });
                      if (widget.onTap != null) {
                        await widget.onTap!();
                      }
                      if (mounted) {
                        setState(() {
                          disabled = false;
                        });
                      }
                    },
              borderRadius: widget.hoverRadius ?? BorderRadius.circular(0),
              splashColor: widget.splashColor ?? Colors.white12,
              hoverColor: widget.hoverColor ?? Colors.transparent,
              radius: widget.splashRadius,
              highlightColor: widget.colorOnClick ?? Colors.transparent,
              child: disabled
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(5),
                            constraints: const BoxConstraints(maxHeight: 30, maxWidth: 30),
                            child: const CircularProgressIndicator(color: Colors.white)),
                      ],
                    )
                  : widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
