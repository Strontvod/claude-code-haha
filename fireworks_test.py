import json
import os
from pathlib import Path

import requests


def load_dotenv(path: str = ".env") -> None:
    env_file = Path(path)
    if not env_file.exists():
        return

    for raw_line in env_file.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue

        key, value = line.split("=", 1)
        os.environ.setdefault(key.strip(), value.strip().strip('"').strip("'"))


def main() -> None:
    load_dotenv()

    api_key = os.getenv("FIREWORKS_API_KEY")
    if not api_key:
        raise SystemExit("FIREWORKS_API_KEY is not set in .env or the environment.")

    response = requests.post(
        "https://api.fireworks.ai/inference/v1/chat/completions",
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        },
        json={
            "model": "accounts/fireworks/models/qwen3p6-plus",
            "messages": [
                {
                    "role": "user",
                    "content": [
                        {"type": "text", "text": "Can you describe this image?"},
                        {
                            "type": "image_url",
                            "image_url": {
                                "url": "https://images.unsplash.com/photo-1582538885592-e70a5d7ab3d3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1770&q=80"
                            },
                        },
                    ],
                }
            ],
            "max_tokens": 1200,
        },
        timeout=60,
    )
    response.raise_for_status()

    data = response.json()

    choice = data.get("choices", [{}])[0]
    message = choice.get("message", {})
    content = message.get("content")
    reasoning_content = message.get("reasoning_content")

    if isinstance(content, str) and content.strip():
        print(content)
        return

    if isinstance(content, list):
        text_parts = [
            part.get("text", "")
            for part in content
            if isinstance(part, dict) and part.get("type") == "text"
        ]
        text_output = "\n".join(part for part in text_parts if part).strip()
        if text_output:
            print(text_output)
            return

    if isinstance(reasoning_content, str) and reasoning_content.strip():
        print(reasoning_content)
        return

    print(json.dumps(data, indent=2))


if __name__ == "__main__":
    main()
