generator :post do
  desc "Generate a new blog post."
  arguments do
    title     :required => true
    timestamp :required => false,
              :default  => proc { DateTime.now.utc },
              :parse    => proc { |val| DateTime.parse(val) }
    draft     :required => false,
              :default  => false,
              :is_flag  => true
  end
  scaffold do
    title           = args.title
    title_fname     = title.gsub(/\s+/, '_').downcase
    timestamp       = args.timestamp#.in_project_timezone
    timestamp_fname = timestamp.strftime('%Y%m%d%H%M%S')

    if(args.draft)
      target_dir      = '_drafts'
      target_fname    = "#{title_fname}"
    else
      target_dir      = '_posts'
      target_fname    = "#{timestamp_fname}_#{title_fname}"
    end

    dir target_dir do
      page target_fname,
        :front_matter => {
          :title        => title,
          :date         => timestamp,
          :layout       => :post,
          :comments     => true,
          :external_url => nil,
          :categories   => nil
        }
    end
  end
end
