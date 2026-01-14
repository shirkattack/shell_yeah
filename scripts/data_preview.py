#!/usr/bin/env python3
import sys
import json
import pandas as pd
from pathlib import Path
from rich.console import Console
from rich.table import Table
from rich.panel import Panel

console = Console()

# Security: Maximum file size to prevent DoS attacks
MAX_FILE_SIZE = 100 * 1024 * 1024  # 100MB

def format_file_size(size_bytes):
    for unit in ['B', 'KB', 'MB', 'GB']:
        if size_bytes < 1024.0:
            return f"{size_bytes:.2f} {unit}"
        size_bytes /= 1024.0
    return f"{size_bytes:.2f} TB"

def preview_data(file_path):
    # Security: Resolve to absolute path to prevent path traversal
    file_path = Path(file_path).resolve()

    # Security: Verify file exists
    if not file_path.exists():
        console.print(f"[red]Error:[/red] File not found: {file_path}")
        sys.exit(1)

    # Security: Verify it's a regular file (not a directory, symlink, etc.)
    if not file_path.is_file():
        console.print(f"[red]Error:[/red] Not a regular file: {file_path}")
        sys.exit(1)

    # Security: Check file size to prevent loading huge files
    file_size_bytes = file_path.stat().st_size
    if file_size_bytes > MAX_FILE_SIZE:
        console.print(f"[red]Error:[/red] File too large ({format_file_size(file_size_bytes)})")
        console.print(f"Maximum allowed size is {format_file_size(MAX_FILE_SIZE)}")
        sys.exit(1)

    file_size = format_file_size(file_size_bytes)
    
    try:
        if file_path.suffix.lower() == '.csv':
            df = pd.read_csv(file_path)
            data_type = "CSV"
        elif file_path.suffix.lower() == '.json':
            with open(file_path) as f:
                data = json.load(f)
            # Handle nested JSON where data is in a root key
            if isinstance(data, dict) and len(data) == 1:
                root_key = list(data.keys())[0]
                if isinstance(data[root_key], list):
                    df = pd.json_normalize(data[root_key])
                else:
                    df = pd.json_normalize(data)
            elif isinstance(data, list):
                df = pd.json_normalize(data)
            else:
                df = pd.json_normalize(data)
            data_type = "JSON"
        else:
            console.print(f"[red]Error:[/red] Unsupported file type. Please use .csv or .json files.")
            sys.exit(1)
        
        # File info panel
        info_table = Table.grid(padding=1)
        info_table.add_column(style="cyan", justify="right")
        info_table.add_column(style="green")
        info_table.add_row("File:", str(file_path))
        info_table.add_row("Type:", data_type)
        info_table.add_row("Size:", file_size)
        info_table.add_row("Rows:", str(len(df)))
        info_table.add_row("Columns:", str(len(df.columns)))
        console.print(Panel(info_table, title="📊 File Information", border_style="blue"))
        
        # Column info
        col_table = Table(show_header=True, header_style="bold magenta")
        col_table.add_column("Column Name")
        col_table.add_column("Data Type")
        col_table.add_column("Non-Null Count")
        col_table.add_column("Sample Values")
        
        for col in df.columns:
            sample_values = df[col].dropna().head(3).tolist()
            sample_str = ", ".join(str(x) for x in sample_values)
            if len(sample_str) > 50:
                sample_str = sample_str[:47] + "..."

            # Calculate percentage, handling empty dataframes
            non_null_count = df[col].count()
            total_rows = len(df)
            percentage = (non_null_count / total_rows * 100) if total_rows > 0 else 0.0

            col_table.add_row(
                str(col),
                str(df[col].dtype),
                f"{non_null_count}/{total_rows} ({percentage:.1f}%)",
                sample_str
            )
        
        console.print(Panel(col_table, title="📋 Column Summary", border_style="green"))
        
        # Data preview
        console.print("\n[bold cyan]📝 Data Preview (first 5 rows):[/bold cyan]")
        console.print(df.head().to_string())
        
    except Exception as e:
        console.print(f"[red]Error:[/red] Failed to process file: {str(e)}")
        import traceback
        console.print(traceback.format_exc())
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        console.print("[red]Error:[/red] Please provide a file path")
        console.print("Usage: data_preview.py <file_path>")
        sys.exit(1)
    
    preview_data(sys.argv[1])
