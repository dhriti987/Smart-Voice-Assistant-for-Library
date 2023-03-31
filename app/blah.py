def cypher(text: str, key):
    # text = text.replace(' ', '')
    d = {key[i]: text[i::len(key)] for i in range(len(key))}
    return "".join([d[key] for key in sorted(list(d.keys()))])


print(cypher("Geeks for Geeks", "HACK"))
