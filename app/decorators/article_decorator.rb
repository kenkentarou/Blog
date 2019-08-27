module ArticleDecorator
  def eye_cache_url(version = :origin)
    if !eye_cache.attached? || eye_cache.metadata.blank?
      return '/images/eye_cache.jpg'
    end

    command = case version
              when :thumb
                { resize: '640x480' }
              when :lg
                { resize: '1024x768' }
              when :ogp
                { resize: '120x630' }
              else
                false
              end

    command ? eye_cache.variant(command).processed : eye_cache
  end
end
