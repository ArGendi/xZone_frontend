import 'package:flutter/material.dart';
import '../constants.dart';

class ChoosePriority extends StatelessWidget {
  final Function(int p) onclick;

  const ChoosePriority({Key key, this.onclick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Card(
        color: backgroundColor,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: (){
                  onclick(1);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Priority 1 \t (Highest)',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){ onclick(2); },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Priority 2',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){ onclick(3); },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Priority 3',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){ onclick(4); },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Priority 4',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
