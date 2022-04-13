# Golomb sequence, python implementation


def gpos(n):
    """Return the value of position n of the Golomb sequence (recursive function)."""
    if n == 1:
        return 1
    return gpos(n - gpos(gpos(n - 1))) + 1


def golomb_sequence(size):
    return [gpos(i) for i in range(1, size + 1)]


def main(size=None):
    if not size:
        size = 50
    sequence = golomb_sequence(int(size))
    print(f"length of sequence: {len(sequence)}, last element: {sequence[-1]}")


if __name__ == "__main__":
    main()
