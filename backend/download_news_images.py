import json
import os
import requests
import urllib.parse
from uuid import uuid4

news_file = 'data/news.json'
images_dir = 'data/images/news'
os.makedirs(images_dir, exist_ok=True)

with open(news_file, 'r', encoding='utf-8') as f:
    news_data = json.load(f)

for item in news_data:
    image_url = item.get('imageUrl')
    if image_url and image_url.startswith('http'):
        print(f"Downloading {image_url}")
        try:
            # Generate a clean filename
            ext = image_url.split('.')[-1]
            if len(ext) > 4 or '?' in ext:
                ext = 'jpg'
            filename = f"news_{uuid4().hex[:8]}.{ext}"
            filepath = os.path.join(images_dir, filename)
            
            # Download image
            response = requests.get(image_url, timeout=10)
            response.raise_for_status()
            with open(filepath, 'wb') as f:
                f.write(response.content)
            
            # Update url
            item['imageUrl'] = f"http://10.0.2.2:8000/static/images/news/{filename}"
            print(f"Saved to {filepath}")
        except Exception as e:
            print(f"Failed to download {image_url}: {e}")

with open(news_file, 'w', encoding='utf-8') as f:
    json.dump(news_data, f, indent=4, ensure_ascii=False)
print("Updated news.json")
