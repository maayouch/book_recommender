# Book Recommender

A book recommendation system built in Python on the [Goodbooks-10k](https://github.com/zygmuntz/goodbooks-10k) dataset (10,000 books, ~6 million ratings). It compares a popularity baseline, a content-based recommender (TF-IDF + cosine similarity) and a k-means clustering of books into genres.

**Example**: books recommended for *Pride and Prejudice*, using k-means clusters and excluding books by the same author:

| Rank | Book | Author | Cosine similarity |
| --- | --- | --- | --- |
| 1 | Wuthering Heights | Emily Brontë | 0.951 |
| 2 | North and South | Elizabeth Gaskell | 0.927 |
| 3 | Tess of the D'Urbervilles | Thomas Hardy | 0.917 |
| 4 | A Tale of Two Cities / Great Expectations | Charles Dickens | 0.912 |
| 5 | Wives and Daughters | Elizabeth Gaskell | 0.908 |

## Highlights

- **Exploratory analysis** of ~6M ratings: a 99% sparse user × book matrix, a long-tail popularity distribution, and noisy user-generated tags.
- **Popularity baseline** using a weighted rating (IMDb-style) to avoid favouring books with only a few ratings.
- **Content-based recommender**: TF-IDF on authors and Goodreads tags, cosine similarity (equivalent to a k-nearest-neighbours search).
- **k-means clustering**: tag cleaning, TF-IDF, truncated SVD (LSA), choice of k with the elbow method and the silhouette score. The 15 clusters match recognisable genres (classics, crime, epic fantasy, young adult, comics…) without the model ever being given a genre.

## Dataset

[Goodbooks-10k](https://github.com/zygmuntz/goodbooks-10k), by Zygmunt Zając, built from Goodreads data:

| File | Content |
| --- | --- |
| `books.csv` | metadata for 10,000 books |
| `ratings.csv` | 5,976,479 ratings (1–5 stars) from 53,424 users |
| `book_tags.csv` | number of times each tag was applied to each book |
| `tags.csv` | tag names (34,252 tags) |

The data is not stored in this repository. Download it with `./download_data.sh` (see below).

## Methods and results

### 1. Exploratory analysis — [`01_exploration.ipynb`](notebooks/01_exploration.ipynb)

![Distribution of ratings](figures/rating_distribution.png)

- 69% of ratings are 4 or 5 stars (mean 3.92).
- Only 1.1% of the user × book matrix is filled.
- The 10% most-rated books receive 53% of all ratings.
- The most frequent tags (`to-read`, `favorites`, `owned`…) describe the reader's shelf, not the book: they must be removed before using tags as features.

### 2. Baselines — [`02_popularity_and_content_based.ipynb`](notebooks/02_popularity_and_content_based.ipynb)

- **Popularity**: ranking by weighted rating. Not personalised; the top 10 is dominated by *Harry Potter*.
- **Content-based**: each book becomes a TF-IDF vector of its authors and 20 most frequent tags; recommendations are the books with the highest cosine similarity. The author weighs heavily, so results are first filled with the same author's books; an option to exclude them makes the results more diverse.

### 3. k-means clustering — [`03_kmeans_clustering.ipynb`](notebooks/03_kmeans_clustering.ipynb)

Pipeline: tag cleaning (34,252 → 2,633 tags) → book × tag matrix with `log(1 + count)` and TF-IDF → truncated SVD to 100 dimensions → L2 normalisation (so that Euclidean k-means groups books by cosine similarity) → k-means.

![Choice of k](figures/k_selection.png)

Neither the elbow method nor the silhouette score shows a clear optimum, which is expected when genres overlap. k = 15 was chosen because it gives interpretable, balanced clusters (347 to 1,015 books each):

| Cluster | Top tags | Most-rated books |
| --- | --- | --- |
| Classics | classics, classic-literature | To Kill a Mockingbird, The Great Gatsby |
| Crime | mystery, crime, thriller | Angels & Demons, The Girl with the Dragon Tattoo |
| Epic fantasy | epic-fantasy, high-fantasy | The Hobbit, A Game of Thrones |
| Young adult (speculative) | ya, young-adult, fantasy | The Hunger Games, Divergent |
| Young adult (realistic) | ya-contemporary, realistic-fiction | The Fault in Our Stars, Looking for Alaska |
| Paranormal romance | vampires, paranormal-romance | Twilight, City of Bones |
| Comics | comics, comic-books, manga | Watchmen, V for Vendetta |

*7 of the 15 clusters shown; the full table is in the notebook.*

Recommendations are then made within the book's cluster, ranked by cosine similarity (example at the top of this page).

## Project structure

```
book_recommender/
├── data/                  # dataset, downloaded by download_data.sh (not versioned)
├── figures/               # charts exported by the notebooks
├── notebooks/
│   ├── 01_exploration.ipynb
│   ├── 02_popularity_and_content_based.ipynb
│   └── 03_kmeans_clustering.ipynb
├── download_data.sh
├── requirements.txt
└── README.md
```

## Getting started

```bash
git clone https://github.com/maayouch/book_recommender.git
cd book_recommender

# create an environment (conda or venv) with Python 3.11+
conda create -n bookrec python=3.11
conda activate bookrec
pip install -r requirements.txt

# download the dataset (~90 MB) into data/
./download_data.sh

# open the notebooks
jupyter notebook notebooks/
```

Run the notebooks in order. Results are reproducible (`random_state = 42`). Tested with Python 3.13, pandas 3.0, scikit-learn 1.9.


## Author

Maryem Ayouch — engineering student at ENSEIRB-MATMECA (Bordeaux, France).
