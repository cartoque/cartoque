Rails.application.config.middleware.use PDFKit::Middleware, 
                                        :print_media_type => true,
                                        :margin_top => "5mm", :margin_bottom => "5mm",
                                        :margin_right => "5mm", :margin_left => "5mm"
