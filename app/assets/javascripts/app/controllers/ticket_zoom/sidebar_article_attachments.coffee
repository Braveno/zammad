class SidebarArticleAttachments extends App.Controller
  sidebarItem: =>
    return if !@Config.get('ui_ticket_zoom_sidebar_article_attachments')
    @item = {
      name: 'attachment'
      badgeIcon: 'paperclip'
      sidebarHead: 'Attachments'
      sidebarCallback: @showObjects
      sidebarActions: []
    }
    @item

  showObjects: (el) =>
    @el = el

    if !@ticket || _.isEmpty(@ticket.article_ids)
      @el.html("<div>#{App.i18n.translateInline('none')}</div>")
      return
    html = ''
    for ticket_article_id, index in @ticket.article_ids
      article = App.TicketArticle.find(ticket_article_id)
      if article && article.attachments && !_.isEmpty(article.attachments)
        html = App.view('ticket_zoom/sidebar_article_attachment')(article: article) + html
    @el.html(html)
    @el.delegate('.js-attachments img', 'click', (e) =>
      @imageView(e)
    )

  imageView: (e) ->
    e.preventDefault()
    e.stopPropagation()
    new App.TicketZoomArticleImageView(image: $(e.target).get(0).outerHTML)

App.Config.set('900-ArticleAttachments', SidebarArticleAttachments, 'TicketZoomSidebar')
