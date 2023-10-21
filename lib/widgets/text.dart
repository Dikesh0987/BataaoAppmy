// @override
// Widget build(BuildContext context) {
//   return Padding(
//     padding: EdgeInsets.only(top: 5, left: 2, right: 2),
//     child: Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: Column(
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 10.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             ViewProfileScreen(user: widget.cuser),
//                       ),
//                     );
//                   },
//                   child: ListTile(
//                     leading: Container(
//                       width: 50.0,
//                       height: 50.0,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black45,
//                             offset: Offset(0, 2),
//                             blurRadius: 6.0,
//                           ),
//                         ],
//                       ),
//                       child: CircleAvatar(
//                         child: ClipOval(
//                           child: Image(
//                             height: 50.0,
//                             width: 50.0,
//                             image: NetworkImage(widget.cuser.images),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//                     title: Text(
//                       '${widget.cuser.name}',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     subtitle: Text(myDateUtil.getFormattedTime(
//                       context: context,
//                       time: widget.post.sent,
//                     )),
//                     trailing: OutlinedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 ViewProfileScreen(user: widget.cuser),
//                           ),
//                         );
//                       },
//                       child: Text("view"),
//                       style: OutlinedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         side: BorderSide(
//                           width: 1,
//                           color: Colors.blue,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   onDoubleTap: () => print('Like post'),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => ViewPostScreen(
//                           post: widget.post,
//                           cuser: widget.cuser,
//                           postsId: widget.postsId,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     margin: EdgeInsets.all(10.0),
//                     width: double.infinity,
//                     height: 400.0,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(25.0),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Color.fromARGB(115, 235, 231, 231),
//                           offset: Offset(0, 5),
//                           blurRadius: 8.0,
//                         ),
//                       ],
//                     ),
//                     child: Stack(
//                       children: [
//                         CachedNetworkImage(
//                           imageUrl: widget.post.link,
//                           fit: BoxFit.cover,
//                           placeholder: (context, url) => _buildImageLoader(),
//                           errorWidget: (context, url, error) =>
//                               Icon(Icons.error),
//                         ),
//                         Positioned(
//                           bottom: 5,
//                           right: 15,
//                           child: Text(
//                             "Location: ${widget.post.location}",
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(.8),
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Rest of your code...
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Widget _buildImageLoader() {
//   return Shimmer.fromColors(
//     baseColor: Colors.grey[300],
//     highlightColor: Colors.grey[100],
//     child: Container(
//       color: Colors.white,
//     ),
//   );
// }
