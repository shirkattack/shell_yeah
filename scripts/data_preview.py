#!/usr/bin/env python3
import sys
import json
import pandas as pd
from pathlib import Path
import rich
from rich.console import Console
from rich.table import Table
from rich.panel import Panel

console = Console()

def format_file_size(size_bytes):
    for unit in ['B', 'KB', 'MB', 'GB']:
        if size_bytes < 1024.0:
            return f"{size_bytes:.2f} {unit}"
        size_bytes /= 1024.0
    return f"{size_bytes:.2f} TB"

def preview_data(file_path):
    file_path = Path(file_path)
    
    if not file_path.exists():
        console.print(f"[red]Error:[/red] File {file_path} does not exist")
        return
    
    file_size = format_file_size(file_path.stat().st_size)
    
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
            return
        
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
            
            col_table.add_row(
                str(col),
                str(df[col].dtype),
                f"{df[col].count()}/{len(df)} ({(df[col].count()/len(df)*100):.1f}%)",
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

if __name__ == "__main__":
    if len(sys.argv) != 2:
        console.print("[red]Error:[/red] Please provide a file path")
        console.print("Usage: data_preview.py <file_path>")
        sys.exit(1)
    
    preview_data(sys.argv[1])
