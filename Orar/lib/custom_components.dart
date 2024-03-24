import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final void Function() function;
  final String text;

  const Button({super.key, required this.function, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: function,
        child: Container(
          height: 60,
          width: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).highlightColor,
                Theme.of(context).highlightColor.withOpacity(.5),
              ],
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: "Roboto",
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextBox extends StatefulWidget {
  final String? initialValue;
  final bool isReadOnly;
  final TextEditingController? controller;
  final String labelText;
  final String? errorText;
  final bool error;
  final bool isPassword;
  final ValueChanged<bool> onChanged;

  const TextBox({
    super.key,
    required this.labelText,
    required this.controller,
    this.error = false,
    this.isPassword = false,
    this.errorText,
    this.isReadOnly = false,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            widget.onChanged(true);
          });
        },
        keyboardAppearance: Theme.of(context).brightness,
        keyboardType: widget.isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
        readOnly: widget.isReadOnly,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: widget.error ? Colors.red : Theme.of(context).textTheme.labelMedium?.color,
            ),
        autocorrect: false,
        initialValue: widget.initialValue,
        minLines: 1,
        maxLines: widget.isPassword ? 1 : 3,
        obscureText: widget.isPassword,
        controller: widget.controller,
        cursorColor: widget.error ? Colors.red : Theme.of(context).shadowColor,
        decoration: InputDecoration(
          focusColor: Theme.of(context).shadowColor,
          labelText: widget.labelText,
          labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: widget.error ? Colors.red : Theme.of(context).textTheme.labelMedium?.color,
              ),
          errorText: widget.error ? widget.errorText : null,
          errorStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.red,
              ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 2, color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 2, color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.onPrimary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
    );
  }
}
