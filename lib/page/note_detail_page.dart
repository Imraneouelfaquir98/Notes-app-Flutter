import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/Provider/theme_provider.dart';
import 'package:notes_app/db/notes_database.dart';
import 'package:notes_app/google_ads/ad_state.dart';
import 'package:notes_app/model/note.dart';
import 'package:notes_app/page/edit_note_page.dart';
import 'package:provider/provider.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {

  BannerAd? banner;
  InterstitialAd? interstitialAd;

  @override
  void dispose() {
    if( banner != null)
      banner!.dispose();
    if( interstitialAd != null)
      interstitialAd!.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then(
            (status){
          setState(
                  (){
                banner = BannerAd(
                    adUnitId: adState.bannerAdUnitUd,
                    size: AdSize.banner,
                    request: AdRequest(),
                    listener: adState.adListener
                )..load();

                if(AdManager.nbr_1 % AdManager.period_1 == 0)
                  InterstitialAd.load(
                      adUnitId: adState.interstitialAdUnitUd,
                      request: AdRequest(),
                      adLoadCallback: InterstitialAdLoadCallback(
                        onAdLoaded: (InterstitialAd ad) {
                          this.interstitialAd = ad;
                        },
                        onAdFailedToLoad: (LoadAdError error) {
                          print('InterstitialAd failed to load: $error');
                        },
                      ));
              }
          );
        }
    );
  }

  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    this.note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      if( AdManager.nbr_1 % AdManager.period_1 == 0) {
        if(interstitialAd != null){
          interstitialAd!.show();
          AdManager.nbr_1++;
          return true;
        }
        else return true;
      }
      else{
        AdManager.nbr_1++;
        return true;
      }
    },
    child: Scaffold(
          appBar: AppBar(
            actions: [editButton(), deleteButton()],
            leading: Builder(
              builder: (BuildContext context) => IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800,
                  ),
                  onPressed: (){
                    print(AdManager.nbr_1 % AdManager.period_1);
                    if( AdManager.nbr_1 % AdManager.period_1 == 0 && interstitialAd != null)
                      interstitialAd!.show();
                    AdManager.nbr_1++;
                    Navigator.pop(context);
                  }
              ),
            ),
          ),
          body: Stack(
            children: [
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      note.title,
                      style: TextStyle(
                        color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      DateFormat.yMMMd().format(note.createdTime),
                      style: TextStyle(color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white38:Colors.blueGrey.shade400),
                    ),
                    SizedBox(height: 8),
                    Text(
                      note.description,
                      style: TextStyle(color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white70:Colors.blueGrey.shade600, fontSize: 18),
                    )
                  ],
                ),
              ),
              if(banner != null)
                Column(
                  children: [
                    Expanded(child: Container()),
                    Container(
                      height: 50,
                      child: AdWidget(ad: banner!,),
                    )
                  ],
                )
            ],
          )
        ),
  );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined, color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800,),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note),
        ));

        refreshNote();
      });

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete, color: Provider.of<ThemeProvider>(context).isDarkMode? Colors.white:Colors.blueGrey.shade800,),
        onPressed: () async {
          await NotesDatabase.instance.delete(widget.noteId);

          Navigator.of(context).pop();
        },
      );
}
