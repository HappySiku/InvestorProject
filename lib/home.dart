import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your total asset portfolio',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₦203,935',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          onPressed: () {},
                          child: Text('Invest now',
                              style: TextStyle(
                                  color: Colors.green,

                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Best Plans',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  Row(
                    children: [
                      Text(
                        'See All',
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.red,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              // add a carousel
              CarouselSlider.builder(
                itemCount: 3,
                itemBuilder: (context, index, realIndex) {
                  switch (index) {
                    case 0:
                      return PlanCard(
                        color: Colors.yellow[700]!!,
                        title: 'Gold',
                        returnPercentage: '30% return',
                      );
                    case 1:
                      return PlanCard(
                        color: Colors.green,
                        title: 'Silver',
                        returnPercentage: '60% return',
                      );
                    case 2:
                      return PlanCard(
                        color: Colors.red,
                        title: 'Platinum',
                        returnPercentage: '90% return',
                      );
                    default:
                      return PlanCard(
                        color: Colors.blue,
                        title: 'Gold',
                        returnPercentage: '30% return',
                      );
                  }
                },
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.2,
                  enableInfiniteScroll: true,
                  viewportFraction: 0.3,

                ),
              ),

              SizedBox(height: 20),
              Text(
                'Investment Guide',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              const InvestmentGuideItem(
                title: 'Basic type of investments',
                description:
                    'This is how you set your foot for 2020 Stock market recession. What’s next...',
              ),
              const InvestmentGuideItem(
                title: 'How much can you start with...',
                description:
                    'What do you like to see? It’s a very different market from 2018. The way...',
              ),
              InvestmentGuideItem(
                title: 'Welcome to New NASDAQ',
                description:
                    'What do you like to see? It’s a very different market from 2018. The way...',
              ),
              InvestmentGuideItem(
                title: 'Welcome to New NASDAQ',
                description:
                    'What do you like to see? It’s a very different market from 2018. The way...',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final Color color;
  final String title;
  final String returnPercentage;

  const PlanCard({
    Key? key,
    required this.color,
    required this.title,
    required this.returnPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            returnPercentage,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class InvestmentGuideItem extends StatelessWidget {
  final String title;
  final String description;

  const InvestmentGuideItem({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          trailing: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.book, color: Colors.white),
          ),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(description),
        ),
        Divider(),
      ],
    );
  }
}
