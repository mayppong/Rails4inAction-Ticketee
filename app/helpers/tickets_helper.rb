module TicketsHelper

  def state_for( comment )
    content_tag( :div, class: "states" ) do
      if comment.state
        previous_state = comment.previous_state
        if previous_state && comment.state != previous_state
           # why do I need to call render on this?
          "#{ render(previous_state) } &rarr; #{ render(comment.state) }"
        else
          render( comment.state )
        end
      end
    end
  end
end
