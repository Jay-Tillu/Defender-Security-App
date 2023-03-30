import 'package:flutter/material.dart';
import 'package:defender/utilities/size_config.dart';

class CSettingsContainer extends StatelessWidget {
  CSettingsContainer({
    @required this.buttonIcon,
    @required this.onButtonPressed,
    @required this.settingName,
    @required this.containerColor,
    @required this.borderColor,
  });

  final String settingName;
  final IconData buttonIcon;
  final Function onButtonPressed;
  final Color containerColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: Container(
        alignment: Alignment.bottomCenter,
        width: SizeConfig.blockSizeHorizontal * 35,
        height: SizeConfig.blockSizeVertical * 18,
        decoration: BoxDecoration(
          color: containerColor,
          boxShadow: [
            BoxShadow(
              color: borderColor,
              spreadRadius: 1,
            ),
          ],
          borderRadius: BorderRadius.circular(
            SizeConfig.blockSizeHorizontal * 4,
          ),
        ),
        child: InkWell(
          onTap: onButtonPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: SizeConfig.blockSizeVertical * 1,
                ),
                child: Center(
                  child: Icon(
                    buttonIcon,
                    color: Colors.black,
                    size: SizeConfig.blockSizeHorizontal * 11,
                  ),
                ),
              ),
              Text(
                settingName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: SizeConfig.blockSizeHorizontal * 4.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
