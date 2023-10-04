import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quizzy/api_caller/campaign.dart';
import 'package:quizzy/components/campaign/campaign_quiz_list.dart';
import 'package:quizzy/components/campaign/campaign_skeleton.dart';
import 'package:quizzy/configs/variables.dart';
import 'package:quizzy/models/campaign.dart';
import 'package:quizzy/provider/login_provider.dart';
import 'package:shimmer/shimmer.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(300.0);
  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final CampaignApi campaignApi = CampaignApi();
  bool isLoading = false;

  Campaign? campaign;
  @override
  void initState() {
    super.initState();
    getCampaign();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> getCampaign() async {
    setState(() {
      isLoading = true;
    });
    try {
      Campaign campaignData = await campaignApi.getCampaign();
      setState(() {
        campaign = campaignData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider user = Provider.of<AuthProvider>(context);
    String name = user.name;
    int coin = user.coin;
    ImageProvider<Object>? backgroundImage;
    if (user.profileUrl == null) {
      backgroundImage = const AssetImage("assets/images/avatar.png");
    } else {
      backgroundImage = NetworkImage(user.profileUrl!);
    }
    String coinString = coin.toString();
    DateTime currentDate = DateTime.now();

    bool isUpcoming = campaign?.startDate != null &&
        campaign?.startDate.isAfter(currentDate) == true;
    bool isRunning = campaign?.startDate != null &&
        campaign?.endDate != null &&
        campaign?.startDate.isBefore(currentDate) == true &&
        campaign?.endDate.isAfter(currentDate) == true;

    bool isClosed = campaign?.endDate != null &&
        campaign?.endDate.isBefore(currentDate) == true;
    return AppBar(
        toolbarHeight: 220.0,
        automaticallyImplyLeading: false,
        leading: null,
        backgroundColor: const Color.fromARGB(255, 144, 106, 250),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(40),
          ),
        ),
        actions: [Container()],
        title: Center(
            child: SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: isLoading
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: CircleAvatar(
                                    radius: 20.0,
                                    backgroundColor: Colors.grey[300],
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage: backgroundImage,
                                ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hello",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 30.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Variables.secondaryColor.withOpacity(1),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: Colors.white,
                                width: 1.2,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.emoji_events,
                                      color: Colors.orange,
                                      size: 20.0,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      coinString,
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () {},
                        //   icon: const Icon(Icons.notifications_outlined,
                        //       color: Colors.white),
                        // ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20.0),
                Container(
                  height: 90.0,
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Variables.getSecondaryColorWithOpacity(0.50),
                  ),
                  child: isLoading
                      ? const CampaignSkeleton()
                      : campaign == null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.020 *
                                              2, // Adjust the size accordingly
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.020 *
                                              2, // Adjust the size accordingly
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF7949FF),
                                            Color.fromRGBO(121, 73, 255, 0.42),
                                          ],
                                          stops: [0.1212, 0.8924],
                                          transform: GradientRotation(207.72 *
                                              3.14159265359 /
                                              180), // Convert degrees to radians
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.campaign,
                                          color: Colors
                                              .white, // Make sure to define Variables.primaryColor
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.028,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6.0, width: 6),
                                    Flexible(
                                      child: Text(
                                        "No active campaigns at the moment",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.020,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isUpcoming
                                              ? "Upcoming Competition"
                                              : isRunning
                                                  ? "Running Competition"
                                                  : "Closed Competition",
                                          style: const TextStyle(
                                              fontSize: 12.0,
                                              letterSpacing: 0.5,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          campaign?.campaignName ??
                                              'Loading...',
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.6,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(height: 5),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            '${DateFormat('d MMM, h:mm a').format(campaign!.startDate)} - ${DateFormat('d MMM, h:mm a').format(campaign!.endDate)}',
                                            style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.1,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: isRunning
                                        ? () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CampaignQuizList(
                                                        campaignId:
                                                            campaign!.id),
                                              ),
                                            );
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isRunning
                                          ? Variables.primaryColor
                                          : (isUpcoming || isClosed)
                                              ? Colors.grey
                                              : Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 15.0),
                                    ),
                                    child: const Text(
                                      "Join",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ]),
                )
              ],
            ),
          ),
        )));
  }
}
