module Gollum
  class Wiki
    # Public: Search all pages for this wiki.
    #
    # query - The string to search for
    # options - The options Hash:
    #           :no_binary - Don't show binary files in search.
    #
    # Returns an Array with Objects of page name, count and type of matches
    def search2(query, no_binary = false)
      args = [{}, '-i', '-c']
      args << '-I' if no_binary
      args << query << @ref << '--'
      args << @page_file_dir if @page_file_dir

      results = {}

      @repo.git.grep(*args).split("\n").each do |line|
        result = line.split(':')
        result_1 = result[1]
        # Remove ext only from known extensions.
        # test.pdf => test.pdf, test.md => test
        valid_page = Page::valid_page_name?(result_1)
        file_name = valid_page ? result_1.chomp(::File.extname(result_1)) :
                    result_1
        results[file_name] = {:count => result[2].to_i, :is_page => valid_page}
      end

      # Use git ls-files '*query*' to search for file names. Grep only searches file content.
      # Spaces are converted to dashes when saving pages to disk.
      @repo.git.ls_files({}, "*#{ query.gsub(' ', '-') }*").split("\n").each do |line|
        # Remove ext only from known extensions.
        valid_page = Page::valid_page_name?(line)
        file_name = valid_page ? line.chomp(::File.extname(line)) : line
        # If there's not already a result for file_name then
        # the value is nil and nil.to_i is 0.
        results[file_name] = {:count => results.fetch(file_name, {}).fetch(:count, 0) + 1,
                              :is_page => valid_page}
      end

      results.map do |key,val|
        { :count => val[:count], :name => key, :is_page => val[:is_page] }
      end
    end
  end
end