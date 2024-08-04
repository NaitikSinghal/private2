import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/models/size_option.dart';
import 'package:pherico/utils/text_input.dart';

class ProductSize extends StatefulWidget {
  final TextEditingController controller;
  final SizeOption value;
  final Function(SizeOption?) onChange;
  const ProductSize(
      {super.key,
      required this.controller,
      required this.onChange,
      required this.value});

  @override
  State<ProductSize> createState() => _ProductSizeState();
}

class _ProductSizeState extends State<ProductSize> {
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: size.width * 0.36,
            height: 50,
            child: TextFormField(
              controller: widget.controller,
              autofocus: false,
              decoration: inputDecoration('Size'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r"[0-9.]"),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Container(
            height: 50,
            width: size.width * 0.36,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: inputBoxColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<SizeOption>(
              value: widget.value,
              isExpanded: true,
              hint: const Text('Select size'),
              borderRadius: BorderRadius.circular(10),
              dropdownColor: inputBoxColor,
              underline: const SizedBox(),
              onChanged: widget.onChange,
              items: sizeOption
                  .map<DropdownMenuItem<SizeOption>>((SizeOption option) {
                return DropdownMenuItem<SizeOption>(
                  value: option,
                  child: Text(option.unit),
                );
              }).toList(),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }
}
