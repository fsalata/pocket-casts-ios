import SwiftUI
import PocketCastsDataModel
import PocketCastsUtils

struct SearchHistoryCell: View {
    @EnvironmentObject var theme: Theme

    var entry: SearchHistoryEntry

    private var subtitle: String {
        if let episode = entry.episode {
            return "\(L10n.episode) • \(TimeFormatter.shared.multipleUnitFormattedShortTime(time: TimeInterval(episode.duration ?? 0))) • \(episode.podcastTitle)"
        } else if let podcast = entry.podcast {
            return [L10n.podcastSingular, podcast.author].compactMap { $0 }.joined(separator: " • ")
        }

        return ""
    }

    var body: some View {
        ZStack {
            Button(action: {
                print("row tapped")
            }) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .buttonStyle(ListCellButtonStyle())

            VStack(spacing: 12) {
                HStack(spacing: 0) {
                    if let title = entry.podcast?.title ?? entry.episode?.title,
                        let uuid = entry.podcast?.uuid ?? entry.episode?.podcastUuid {
                        PodcastCover(podcastUuid: uuid)
                            .frame(width: 48, height: 48)
                            .allowsHitTesting(false)
                            .padding(.trailing, 12)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(title)
                                .font(style: .subheadline, weight: .medium)
                                .foregroundColor(AppTheme.color(for: .primaryText01, theme: theme))
                                .lineLimit(2)
                            Text(subtitle)
                                .font(size: 14, style: .subheadline, weight: .medium)
                                .foregroundColor(AppTheme.color(for: .primaryText02, theme: theme))
                                .lineLimit(1)
                        }
                        .allowsHitTesting(false)
                    } else if let searchTerm = entry.searchTerm {
                        Image("custom_search")
                            .frame(width: 48, height: 48)
                            .foregroundColor(AppTheme.color(for: .primaryText02, theme: theme))
                            .padding(.trailing, 12)
                        Text(searchTerm)
                            .font(style: .subheadline, weight: .medium)
                    }

                    Spacer()
                    Button(action: {
                        print("remove tapped")
                    }) {
                        Image("close")
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    .frame(width: 48, height: 48)
                }
                ThemedDivider()
                    .frame(height: 1)
            }
            .padding(EdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 0))
        }
    }
}
