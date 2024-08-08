module MessageFormatHelper
  include RegexHelper



  def render_message_content(message_content)
    ChatwootMarkdownRenderer.new(message_content).render_message
  end
end
