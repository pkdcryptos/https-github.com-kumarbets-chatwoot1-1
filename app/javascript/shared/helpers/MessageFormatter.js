import mila from 'markdown-it-link-attributes';


const setImageHeight = inlineToken => {
  const imgSrc = inlineToken.attrGet('src');
  if (!imgSrc) return;
  const url = new URL(imgSrc);
  const height = url.searchParams.get('cw_image_height');
  if (!height) return;
  inlineToken.attrSet('style', `height: ${height};`);
};

const processInlineToken = blockToken => {
  blockToken.children.forEach(inlineToken => {
    if (inlineToken.type === 'image') {
      setImageHeight(inlineToken);
    }
  });
};

const imgResizeManager = md => {
  // Custom rule for image resize in markdown
  // If the image url has a query param cw_image_height, then add a style attribute to the image
  md.core.ruler.after('inline', 'add-image-height', state => {
    state.tokens.forEach(blockToken => {
      if (blockToken.type === 'inline') {
        processInlineToken(blockToken);
      }
    });
  });
};

const md = require('markdown-it')({
  html: false,
  xhtmlOut: true,
  breaks: true,
  langPrefix: 'language-',
  linkify: true,
  typographer: true,
  quotes: '\u201c\u201d\u2018\u2019',
  maxNesting: 20,
})
  .use(imgResizeManager)
  .use(mila, {
    attrs: {
      class: 'link',
      rel: 'noreferrer noopener nofollow',
      target: '_blank',
    },
  });


class MessageFormatter {
  constructor(message, isATweet = false, isAPrivateNote = false) {
    this.message = message || '';
    this.isAPrivateNote = isAPrivateNote;
    this.isATweet = isATweet;
  }

  formatMessage() {
    let updatedMessage = this.message;
 
    return md.render(updatedMessage);
  }

  get formattedMessage() {
    return this.formatMessage();
  }

  get plainText() {
    const strippedOutHtml = new DOMParser().parseFromString(
      this.formattedMessage,
      'text/html'
    );
    return strippedOutHtml.body.textContent || '';
  }
}

export default MessageFormatter;
