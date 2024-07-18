import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientFeedbackScreen extends StatefulWidget {
  const PatientFeedbackScreen({super.key});

  @override
  _PatientFeedbackScreenState createState() => _PatientFeedbackScreenState();
}

class _PatientFeedbackScreenState extends State<PatientFeedbackScreen> {
  bool _isReplying = false; // Track if admin is replying
  String _replyText = ''; // Store admin's reply
  int? _selectedFeedbackIndex; // Track which feedback is selected for replying

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isReplying
            ? const Text('Reply to Feedback')
            : const Text('Patient Feedback'),
        leading: _isReplying
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _isReplying = false; // Stop replying and go back to main screen
                    _selectedFeedbackIndex = null; // Clear selected feedback
                  });
                },
              )
            : null, // Hide back button in main screen
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('patient')
            .doc('Feedbacks')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading feedbacks'));
          }
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(child: Text('No feedbacks found'));
          }

          final data = snapshot.data!.data()!;
          final feedbacks = data.entries.where((entry) => entry.value != '').toList();

          return ListView.builder(
            itemCount: feedbacks.length,
            itemBuilder: (ctx, index) {
              final feedbackEntry = feedbacks[index];
              final feedbackKey = feedbackEntry.key;
              final feedbackValue = feedbackEntry.value;

              return Column(
                children: [
                  ListTile(
                    title: Text(feedbackValue),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_selectedFeedbackIndex == index && _isReplying)
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              _sendReply(feedbackValue, index, feedbackKey);
                            },
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.reply),
                            onPressed: () {
                              setState(() {
                                _isReplying = true; // Start replying to feedback
                                _selectedFeedbackIndex = index; // Select feedback to reply
                              });
                            },
                          ),
                        IconButton(
                          icon: const Icon(Icons.thumb_up),
                          onPressed: () {
                            _acknowledgeFeedback(feedbackKey); // Acknowledge feedback
                          },
                        ),
                      ],
                    ),
                  ),
                  if (_selectedFeedbackIndex == index && _isReplying)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _replyText = value; // Store admin's reply text
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter your reply...',
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _sendReply(String feedback, int index, String feedbackKey) async {
    try {
      // Add reply to the 'replies' sub-collection
      await FirebaseFirestore.instance
          .collection('patient')
          .doc('Feedbacks')
          .collection('replies')
          .add({
        'feedback': feedback,
        'reply': _replyText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Acknowledge feedback
      await _acknowledgeFeedback(feedbackKey);

      // Clear reply text and reset state to stop replying mode
      setState(() {
        _replyText = '';
        _isReplying = false;
        _selectedFeedbackIndex = null; // Clear selected feedback
      });
    } catch (e) {
      print('Error sending reply: $e');
    }
  }

  Future<void> _acknowledgeFeedback(String feedbackKey) async {
    try {
      // Remove feedback from the main document
      await FirebaseFirestore.instance
          .collection('patient')
          .doc('Feedbacks')
          .update({feedbackKey: FieldValue.delete()});

      setState(() {
        _selectedFeedbackIndex = null; // Clear selected feedback
      });
    } catch (e) {
      print('Error acknowledging feedback: $e');
    }
  }
}
