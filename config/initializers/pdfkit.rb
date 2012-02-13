Rails.application.config.middleware.use PDFKit::Middleware,
                                        print_media_type: true,
                                        orientation: 'Portrait', page_size: 'A3',
                                        margin_top: "5mm", margin_bottom: "5mm",
                                        margin_right: "5mm", margin_left: "5mm"
