b = init(DunderUlid)

show_message(is_type(b, DunderUlid));
c = init(DunderUlid, b)
show_message(is_type(b, DunderUlid));
show_message(eq(b, c));