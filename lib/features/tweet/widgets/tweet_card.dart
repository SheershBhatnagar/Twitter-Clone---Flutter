
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:twitter_clone/constants/assets_constants.dart';

import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/theme/pallete.dart';

import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../../../core/enums/tweet_type_enum.dart';
import 'carousel_image.dart';

class TweetCard extends ConsumerWidget {

  final Tweet _tweet;

  const TweetCard({
    super.key,
    required Tweet tweet,
  }) : _tweet = tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDetailsProvider(_tweet.uid)).when(
      data: (user) {
        return Column(
          children: [
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(user.profilePic),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '@${user.name} · ${timeago.format(
                              _tweet.tweetedAt,
                              locale: 'en_short',
                            )}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Pallete.greyColor,
                            ),
                          ),
                        ],
                      ),
                      HashtagText(text: _tweet.text),
                      const SizedBox(height: 10),
                      if(_tweet.tweetType == TweetType.image)
                        CarouselImage(imageLinks: _tweet.imageLinks),
                      if(_tweet.link.isNotEmpty) ... [
                        const SizedBox(height: 5),
                        AnyLinkPreview(
                          link: 'https://${_tweet.link}',
                          displayDirection: UIDirection.uiDirectionHorizontal,
                        ),
                      ],
                      Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                          right: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TweetIconButton(
                              pathName: AssetsConstants.commentIcon,
                              text: _tweet.commentIds.length.toString(),
                              onTap: () {},
                            ),
                            TweetIconButton(
                              pathName: AssetsConstants.retweetIcon,
                              text: _tweet.reshareCount.toString(),
                              onTap: () {},
                            ),
                            LikeButton(
                              size: 23,
                              likeBuilder: (bool isLiked) {
                                return isLiked ? SvgPicture.asset(
                                  AssetsConstants.likeFilledIcon,
                                  color: Pallete.redColor,
                                ) : SvgPicture.asset(
                                  AssetsConstants.likeOutlinedIcon,
                                  color: Pallete.greyColor,
                                );
                              },
                              likeCount: _tweet.likes.length,
                              countBuilder: (likeCount, isLiked, text) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 2.0),
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                      color: isLiked ? Pallete.redColor : Pallete.whiteColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              },
                            ),
                            TweetIconButton(
                              pathName: AssetsConstants.viewsIcon,
                              text: (_tweet.commentIds.length + _tweet.likes.length + _tweet.reshareCount).toString(),
                              onTap: () {},
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.share_outlined,
                                color: Pallete.greyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 1),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(
              color: Pallete.greyColor,
              height: 3,
            ),
          ],
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
