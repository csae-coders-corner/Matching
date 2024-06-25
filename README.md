# Matching

As researchers, we frequently integrate data from various sources. Fuzzy matching is a valuable technique for comparing and matching strings that are not the same but exhibit similar patterns. The stringdist R package offers a wide range of string distance metrics to measure the similarity or dissimilarity between strings.
The function in this piece of code utilizes the Jaro–Winkler distance, a string metric that measures the edit distance between two sequences. The Jaro–Winkler distance provides a normalized score where 0 indicates an exact match and 1 signifies no similarity. Therefore, a lower Jaro–Winkler distance implies greater similarity between the strings.
In the following code, we aim to match data on union councils from a government database with a set of union councils available in a shapefile, to extract geo-spatial information.

**Prabhmeet Matta, Research Assistant, Department of Economics, University of Oxford, 20 June 2024.**

