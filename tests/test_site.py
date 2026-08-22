import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / "docs"
HTML = (DOCS / "index.html").read_text(encoding="utf-8")


class ProjectPageTests(unittest.TestCase):
    def test_metadata_and_accessibility_contract(self):
        self.assertRegex(HTML, r'<meta\s+name="description"')
        self.assertRegex(HTML, r'<link\s+rel="canonical"')
        self.assertIn('property="og:title"', HTML)
        self.assertIn("<main>", HTML)
        self.assertIn("prefers-reduced-motion", HTML)
        self.assertNotIn("fonts.googleapis.com", HTML)

    def test_every_local_page_asset_exists(self):
        references = re.findall(r'(?:src|href)=["\']([^"\']+)', HTML)
        references += re.findall(r'url\(["\']?([^"\')]+)', HTML)
        local_references = [
            reference.split("#", 1)[0].split("?", 1)[0]
            for reference in references
            if reference and not re.match(r"^(?:[a-z]+:|#|//)", reference)
        ]
        self.assertGreaterEqual(len(local_references), 3)
        missing = [reference for reference in local_references if not (DOCS / reference).exists()]
        self.assertEqual([], missing, f"missing page assets: {missing}")


if __name__ == "__main__":
    unittest.main()
