import 'package:flutter/material.dart';
import 'package:galleryapp/custom_image_picker_modal_screen.dart';
import 'package:galleryapp/image_picker_provider.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ImagePickerProvider>(
            create: (_) => ImagePickerProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Center(
            child: RaisedButton(
              child: Text('open gallery'),
              onPressed: () {
                showSlidingBottomSheet(
                  context,
                  builder: (context) {
                    return SlidingSheetDialog(
                      duration: Duration(
                        milliseconds: 200,
                      ),
                      cornerRadius: 30.0,
                      snapSpec: SnapSpec(
                        snap: true,
                        snappings: [1.0],
                        positioning: SnapPositioning.relativeToAvailableSpace,
                      ),
                      builder: (context, state) {
                        return CustomImagePickerModalScreen(
                          height: constraints.maxHeight,
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        }));
  }
}
