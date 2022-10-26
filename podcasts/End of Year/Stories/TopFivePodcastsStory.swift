import SwiftUI
import PocketCastsServer
import PocketCastsDataModel

struct TopFivePodcastsStory: StoryView {
    let podcasts: [Podcast]

    let duration: TimeInterval = 5.seconds

    var backgroundColor: Color {
        Color(podcasts.first?.bgColor() ?? UIColor.black)
    }

    var tintColor: Color {
        .white
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                DynamicBackgroundView(podcast: podcasts[0])

                VStack {
                    Text(L10n.eoyStoryTopPodcasts)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxHeight: geometry.size.height * 0.07)
                        .minimumScaleFactor(0.01)
                        .opacity(0.8)
                        .foregroundColor(tintColor)
                        .padding(.bottom)
                    VStack() {
                        ForEach(0 ..< podcasts.count, id: \.self) { x in
                            HStack(spacing: 16) {
                                Text("\(x + 1).")
                                    .frame(width: 30)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(tintColor)
                                ImageView(ServerHelper.imageUrl(podcastUuid: podcasts[x].uuid, size: 280))
                                    .frame(width: 76, height: 76)
                                    .aspectRatio(1, contentMode: .fit)
                                    .cornerRadius(4)
                                    .shadow(radius: 2, x: 0, y: 1)
                                    .accessibilityHidden(true)
                                VStack(alignment: .leading) {
                                    Text(podcasts[x].title ?? "")
                                        .lineLimit(2)
                                        .font(.system(size: 22, weight: .heavy))
                                        .foregroundColor(.white)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .minimumScaleFactor(0.01)
                                    Text(podcasts[x].author ?? "").font(.system(size: 12, weight: .semibold))
                                        .lineLimit(1)
                                        .font(.system(size: geometry.size.height * 0.07, weight: .bold))
                                        .foregroundColor(.white)
                                        .opacity(0.8)
                                }
                                Spacer()
                            }
                        }
                    }
                    .padding(.leading, 40)
                    .padding(.trailing, 40)
                }
            }
        }
    }
}

struct DummyStory_Previews: PreviewProvider {
    static var previews: some View {
        TopFivePodcastsStory(podcasts: [Podcast.previewPodcast(), Podcast.previewPodcast(), Podcast.previewPodcast(), Podcast.previewPodcast(), Podcast.previewPodcast()])
    }
}
