BEGIN {
    collected_blanks = 0;
    first = 1
}

/^[[:space:]]*$/ {
    collected_blanks++;
}

/[^[:space:]]+/ {
    if (first)
        first = 0
    else
        for (i = 0; i < collected_blanks; i++)
            print "";
        collected_blanks = 0;
    print
}
