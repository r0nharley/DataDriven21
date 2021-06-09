def get_span_value(span_value):
    """
    Return the integer value of how many rows/columns a rowspan/colspan value represents
    :param span_value: the value of the rowspan/colspan html attribute
    :return: integer value of the attribute; returns 1 if the value is not a number
    """
    return int(span_value) if is_number(span_value) else 1


def clean_string(string):
    """
    Removes all extra spaces from a string
    :param string: string to be cleaned
    :return: cleaned string
    """
    clean = string.strip()
    while clean.find('  ') > 0:
        clean = clean.replace('  ', ' ')
    return clean


def get_value(value_string):
    """
    Converts a string containing a value to its numerical representation
    :param value_string: String to be converted
    :return: Numerical value of passed in parameter
    """
    original_value_string = value_string
    value_string = value_string.upper()

    sequence_to_clean = ['$', '%', ',', ' ']
    for s in sequence_to_clean:
        value_string = value_string.replace(s, '')

    multipliers = {'K': 1000, 'M': 1000000, 'B': 1000000000, 'T': 1000000000000}
    multiplier = 1
    for m in multipliers:
        if value_string.endswith(m):
            multiplier = multipliers[m]
            value_string = value_string[:-1]

    return float(value_string) * multiplier if is_number(value_string) else original_value_string


def is_number(value):
    """
    Returns whether or not a value is a number
    :param value: string to evaluate
    :return: true if number otherwise false
    """
    try:
        float(value)
        return True
    except:
        return False
