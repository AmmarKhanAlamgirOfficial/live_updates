module Jekyll
  module CustomEmbeds
    def parse_embeds(input)
      input.gsub(/<a[^>]*href="([^"]+)"[^>]*>(youtube|twitter|twitter-video|instagram|instagram-video|facebook|tiktok|linkedin|reddit|telegram)(?:\|([^<]*))?<\/a>/i) do |match|
        url = $1
        platform = $2.downcase
        caption = $3

        html_output = ""
        caption_html = (caption && !caption.empty?) ? %Q(<div class="embed-caption media-caption">#{caption.strip}</div>) : ""

        case platform
        when 'youtube'
          video_id_match = url.match(/(?:v=|\/embed\/|\/shorts\/|youtu\.be\/)([a-zA-Z0-9_-]{11})/)
          if video_id_match
            video_id = video_id_match[1]
            html_output = %Q(<div class="embed-container my-4"><div class="responsive-iframe-container responsive-iframe-container-16x9"><iframe src="https://www.youtube.com/embed/#{video_id}?rel=0&modestbranding=1" allowfullscreen></iframe></div>#{caption_html}</div>)
          end
        when 'twitter', 'twitter-video'
          clean_url = url.sub('x.com', 'twitter.com').split('?').first
          html_output = %Q(<div class="embed-container my-4"><blockquote class="twitter-tweet" data-dnt="true" data-theme="light"><a href="#{clean_url}"></a></blockquote>#{caption_html}</div>)
        when 'instagram', 'instagram-video'
           html_output = %Q(<div class="embed-container my-4"><blockquote class="instagram-media" data-instgrm-captioned data-instgrm-permalink="#{url}" data-instgrm-version="14"></blockquote>#{caption_html}</div>)
        when 'facebook'
            html_output = %Q(<div class="embed-container my-4"><div class="fb-post" data-href="#{url}" data-width="auto" data-show-text="true"></div>#{caption_html}</div>)
        when 'tiktok'
            video_id = url.split('/').last
            html_output = %Q(<div class="embed-container my-4"><blockquote class="tiktok-embed" cite="#{url}" data-video-id="#{video_id}"><section></section></blockquote>#{caption_html}</div>)
        when 'linkedin'
            html_output = %Q(<div class="embed-container my-4"><div class="linkedin-post" data-href="#{url}"></div>#{caption_html}</div>)
        when 'telegram'
            tg_match = url.match(/t\.me\/([a-zA-Z0-9_]+\/\d+)/)
            if tg_match
                html_output = %Q(<div class="embed-container my-4"><blockquote class="telegram-post" data-post="#{tg_match[1]}" data-width="100%"></blockquote>#{caption_html}</div>)
            end
        when 'reddit'
            html_output = %Q(<div class="embed-container my-4"><blockquote class="reddit-embed-bq" data-embed-height="500"><a href="#{url}">Post</a></blockquote>#{caption_html}</div>)
        end

        html_output.empty? ? match : html_output
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::CustomEmbeds)