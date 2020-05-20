import json

notes_path =  "/Users/bkb/Library/Application Support/Vivaldi//Default/Notes"
output_path = "notes"

class Note:
    def __init__(self, id, subject, content, type, url):
        self.id = id
        self.subject = subject
        self.content = content
        self.type = type
        self.url = url

flattened_notes = {}

def load(node, path):
    for item in node['children']:
        if item['type'] == 'note':
            process_note(item, path)
            
        elif item['type'] == 'folder' or item['type'] == 'other' or item['type'] == 'trash':
            load(item, path + item['id'] + '\\')

def process_note(note, path):
    flattened_notes[note['id']] = Note(note['id'], note['subject'], note['content'], note['type'], note['url'])

with open(notes_path, mode='r', encoding="utf8") as file:
    notes = json.load(file)

load(notes, '')
print('Loaded notes: ' + str(len(flattened_notes.keys())))

with open(output_path, mode='w', encoding="utf8") as file:
    for key, item in flattened_notes.items():
        file.write('Subject: ' + item.subject + '\n')
        file.write('URL: ' + item.url + '\n')
        file.write(item.content + '\n')
        file.write('\n')
